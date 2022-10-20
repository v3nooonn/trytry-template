syntax = "v1"

info (
	title: ""// TODO: add title
	desc: ""// TODO: add description
	author: "{{.gitUser}}"
	email: "{{.gitEmail}}"
)

// Health
type (
	HealthResp {
		Up string `json:"up"`
	}
)

@server(
	group: health
	prefix: health
)
service {{.serviceName}} {
	@handler Health
  	get /up returns (HealthResp)
}
