syntax = "v1"

info (
	title: ""// TODO: add title
	desc: ""// TODO: add description
	author: "{{.gitUser}}"
	email: "{{.gitEmail}}"
)

@server(
	group: ping
	prefix: ping
)
service {{.serviceName}} {
	@handler Ping
  	get / returns (Pong)
}

// Ping
type (
	Pong {
		Up string `json:"up"`
	}
)
