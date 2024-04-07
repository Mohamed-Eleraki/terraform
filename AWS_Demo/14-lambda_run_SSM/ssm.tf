# Create an SSM holds Shell configs
resource "aws_ssm_document" "ssm_document_shell_configs" {
  name          = "ssm_document_shell_configs"
  document_type = "Command"
  content       = file("${path.module}/scripts/ssmShellConfigs.json")
}