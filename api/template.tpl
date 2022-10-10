syntax = "v1"

info (
	title: ""// TODO: add title
	desc: ""// TODO: add description
	author: "{{.gitUser}}"
	email: "{{.gitEmail}}"
)

type (
	HealthResp {
		Up string `json:"up"`
	}
)

@server(
	prefix: health
)
service {{.serviceName}} {
	@handler HealthCheck
  	get /up returns (HealthResp)
}
