Got it ✅ — you want **absolutely everything** (steps + expected results + example outputs) **inside one README.md file only**, no explanations outside.

Here’s the corrected full README (all outputs inline, including the *Buckets* one you pointed out):

```markdown
# AWS FOCUS Setup with CUR, Athena, and Queries

This guide documents step by step how to set up **FOCUS for AWS** using CUR and Athena.  
It includes **commands, configurations, and expected outputs**.

---

## 1. Create S3 Bucket for CUR

1. Go to **S3 Console** → Create bucket.
   - **Bucket name**: `eraki-cur-lab`
   - **Region**: `us-east-1`
   - Keep defaults unless you need specific settings.

✅ After creation, you should see:

```

## Buckets

Name             Region
eraki-cur-lab    us-east-1

```

---

## 2. Enable AWS Cost & Usage Report (CUR)

1. In the AWS console, go to **Billing → Cost & Usage Reports**.
2. Click **Create report**:
   - **Report name**: `focus-cur`
   - Check ✅ **Include resource IDs**
   - Check ✅ **Amortized and blended costs**
   - **Format**: Parquet
   - **S3 bucket**: `s3://eraki-cur-lab/`
   - **Prefix**: `cur/`
   - **Granularity**: Hourly
   - **Refresh**: Daily
   - **Data integration**: Amazon Athena
3. Submit.

⏳ After a few hours, files appear in your S3 bucket:

```

s3://eraki-cur-lab/cur/focus-cur/
└── 2025/09/01/...
└── aws-programmatic-access-test-object

````

---

## 3. Verify CUR in Athena

1. Go to **Athena Console**.
2. Check that the database exists:

```sql
SHOW DATABASES;
````

✅ Expected:

```
Database
----------------------
customer_cur_data
```

3. List tables:

```sql
SHOW TABLES IN customer_cur_data;
```

✅ Expected:

```
focus_cur
```

4. Query raw CUR:

```sql
SELECT *
FROM customer_cur_data.focus_cur
LIMIT 5;
```

✅ Example output:

```
line_item_usage_start_date | bill_payer_account_id | line_item_usage_account_id | product_product_name
-------------------------- | --------------------- | -------------------------- | ---------------------
2025-08-01T00:00:00Z       | 123456789012          | 111122223333               | Amazon Elastic Compute Cloud
2025-08-01T01:00:00Z       | 123456789012          | 111122223333               | Amazon Simple Storage Service
...
```

---

## 4. Create FOCUS-Aligned Dataset

Run this in Athena to create a simplified view:

```sql
CREATE OR REPLACE VIEW customer_cur_data.focus_dataset AS
SELECT
  line_item_usage_start_date         AS BillingPeriodStart,
  bill_payer_account_id              AS BillingAccountId,
  line_item_usage_account_id         AS SubAccountId,
  line_item_usage_account_id         AS SubAccountName,
  product_product_name               AS ServiceName,
  line_item_blended_cost             AS BilledCost,
  line_item_unblended_cost           AS EffectiveCost,
  product_region                     AS Region,
  product_product_family             AS ProductFamily,
  product_usagetype                  AS UsageType,
  line_item_operation                AS Operation,
  resource_tags_user_project         AS ProjectTag
FROM customer_cur_data.focus_cur;
```

Verify:

```sql
SHOW TABLES IN customer_cur_data;
```

✅ Expected:

```
focus_cur
focus_dataset
```

---

## 5. Run FOCUS Query

Example query for EC2 costs:

```sql
SELECT
  BillingPeriodStart,
  'AWS'            AS ProviderName,
  SubAccountId,
  SubAccountName,
  ServiceName,
  SUM(BilledCost)    AS TotalBilledCost,
  SUM(EffectiveCost) AS TotalEffectiveCost
FROM customer_cur_data.focus_dataset
WHERE ServiceName = 'Amazon Elastic Compute Cloud'
  AND BillingPeriodStart >= DATE '2025-08-01'
  AND BillingPeriodStart <  DATE '2025-09-01'
GROUP BY
  BillingPeriodStart,
  ProviderName,
  SubAccountId,
  SubAccountName,
  ServiceName
ORDER BY
  TotalEffectiveCost DESC;
```

✅ Example output:

```
billingperiodstart | providername | subaccountid | subaccountname | servicename                  | totalbilledcost | totaleffectivecost
------------------ | ------------ | ------------ | -------------- | ---------------------------- | --------------- | ------------------
2025-08-01         | AWS          | 111122223333 | 111122223333   | Amazon Elastic Compute Cloud | 45.67           | 45.67
```

---

## 6. Notes & Troubleshooting

* `USE customer_cur_data;` → ❌ Not supported in Athena. Always fully qualify with `customer_cur_data.table_name`.
* `TABLE_NOT_FOUND` → Ensure integration created `focus_cur` in Athena.
* If no data appears, wait longer for CUR files to arrive in S3.

---

✅ You now have AWS CUR → Athena → FOCUS dataset fully working.

```

---

Do you also want me to **embed the error outputs we hit** (like the exact `TABLE_NOT_FOUND` and `Queries of this type are not supported` messages) in this README, so it becomes a “lessons learned” log as well?
```

