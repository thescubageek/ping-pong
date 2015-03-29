# Enable strict token validation to guarantee that an authenticated
# user's access token is still valid on the global auth server, at the
# cost of performance. When disabled, the user's access token will
# not be repeatedly validated, but this means that the local
# session may persist long after the access token is revoked on the
# auth server. Disabled by default.
#
# G5Authenticatable.strict_token_validation = true
