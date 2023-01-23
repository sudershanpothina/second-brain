get provider versions

terraform version

set log levels
export TF_LOG_CORE=TRACE
export TF_LOG_PROVIDER=TRACE
export TF_LOG_PATH=log.txt

terraform refresh

unset log levels
export TF_LOG_CORE=
export TF_LOG_PROVIDER=
export TF_LOG_PATH=