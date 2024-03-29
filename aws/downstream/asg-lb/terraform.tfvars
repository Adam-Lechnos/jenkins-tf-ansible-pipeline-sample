param_workspace_name = "al-test-lb-am"
accountName = "content.qt-build.dev"
image_name = "alechnos_test_all.img"
vm_type = "c5n.large"
vm_count = "0"
devops_release = "v1.0.4"
git_repo = "git@github.factset.com:market-data-cloud/alechnos_test_all.img.git"
build_type = "deploy"
min_healthy_percentage = "50"
health_check_grace_period = "120"
resource = "scale_set_with_load_balancer"
runtime_data = "'region':'am', 'al_test_lb_am' : { 'uniq_name': 'al_test_lb_am'}"
proximity_placement_group_name = ""
scaleset_prefix = "al-test-lb-am"
build_access_set = "non-admin"
image_version = "v0.0.47"
max_size = "4"
desired_capacity = "3"
aws_region = "us-east-1"
alerting_thresholds = "cpu:30 disk:34 mem:55"
min_size = "3"
heartbeat_timeout = "180"
instance_warmup = "180"
username = "alechnos"
image_name_trimmed = "alechnos-test-all"
image_version_trimmed = "v0-0-47"
param_workspace_name_trimmed = "al-test-lb-am"
scaleset_prefix_trimmed = "al-test-lb-am"
