resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = var.listener_arn
  priority     = var.priority

  dynamic "action" {
    for_each = var.action
    content {
      type             = action.value.type
      target_group_arn = lookup(action.value, "target_group_arn", null)
      /*
      redirect             = lookup(action.value, "redirect", null)
      fixed-response       = lookup(action.value, "fixed-response", null)
      authenticate-cognito = lookup(action.value, "authenticate-cognito", null)
      authenticate-oidc    = lookup(action.value, "authenticate-oidc", null)
      */
    }
  }
  /*
  dynamic "redirect" {
    for_each = var.redirect
    content {
      host                 = lookup(redirect.value, "host", "#{host}")
      path                 = lookup(redirect.value, "path", "#{path}")
      port                 = lookup(redirect.value, "port", "#{port}")
      protocol             = lookup(redirect.value, "protocol", "#{protocol}")
      query                = lookup(redirect.value, "query", "#{query}")
      status_code          = redirect.value.status_code
    }
  }

  dynamic "fixed_response" {
    for_each = var.fixed_response
    content {
      content_type         = fixed_response.value.content_type
      message_body         = lookup(fixed_response.value, "message_body", null)
      status_code          = lookup(fixed_response.value, "status_code", null)
    }
  }
  
  dynamic "authenticate_cognito" {
    for_each = var.authenticate_cognito
    content {
      authentication_request_extra_params = lookup(authenticate_cognito.value, "authentication_request_extra_params", null)
      on_unauthenticated_request          = lookup(authenticate_cognito.value, "on_unauthenticated_request", null)
      scope                               = lookup(authenticate_cognito.value, "scope", null)
      session_cookie_name                 = lookup(authenticate_cognito.value, "session_cookie_name", null)
      session_timeout                     = lookup(authenticate_cognito.value, "session_timeout", null)
      user_pool_arn                       = authenticate_cognito.value.user_pool_arn
      user_pool_client_id                 = authenticate_cognito.value.user_pool_client_id
      user_pool_domain                    = authenticate_cognito.value.user_pool_domain
    }
  }
  
  dynamic "authenticate_oidc" {
    for_each = var.authenticate_oidc
    content {
      authentication_request_extra_params = lookup(authenticate_oidc.value, "authentication_request_extra_params", null)
      authorization_endpoint              = authenticate_oidc.value.authorization_endpoint
      client_id                           = authenticate_oidc.value.client_id
      client_secret                       = authenticate_oidc.value.client_secret
      issuer                              = authenticate_oidc.value.issuer
      on_unauthenticated_request          = lookup(authenticate_oidc.value, "on_unauthenticated_request", null)
      scope                               = lookup(authenticate_oidc.value, "scope", null)
      session_cookie_name                 = lookup(authenticate_oidc.value, "session_cookie_name", null)
      token_endpoint                      = authenticate_oidc.value.token_endpoint
      user_info_endpoint                  = authenticate_oidc.value.user_info_endpoint
    }
  }
*/
  dynamic "condition" {
    for_each = var.condition
    content {
      field  = condition.value.field
      values = condition.value.values
    }
  }
}