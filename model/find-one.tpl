
func (m *default{{.upperStartCamelObject}}Model) FindOne(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error) {
    schema := ctxutil.GetTenant(ctx)

    var resp {{.upperStartCamelObject}}

    toSQL, args, err := m.Columns(ctx).Where(
    	squirrel.Eq{"{{.originalPrimaryKey}}": {{.lowerStartCamelPrimaryKey}}},
    ).Limit(1).ToSql()
    if err != nil {
    	return nil, errors.Wrap(err, "toSQL construction error")
    }

	{{if .withCache}}{{.cacheKey}}
	{{.cacheKeyVariable}} = cachekey.SchInj({{.cacheKeyFmt}}, schema)

	err = m.QueryRowCtx(ctx, &resp, {{.cacheKeyVariable}}, func(ctx context.Context, conn sqlx.SqlConn, v interface{}) error {
		return conn.QueryRowCtx(ctx, v, toSQL, args...)
	}){{else}}err = m.conn.QueryRowCtx(ctx, &resp, toSQL, args...){{end}}
	switch err {
	case nil:
		return &resp, nil
	case ErrNotFound:
		return nil, errors.Wrap(err, fmt.Sprintf("{{.upperStartCamelObject}} not found by {{.originalPrimaryKey}}: %v", {{.lowerStartCamelPrimaryKey}}))
	default:
		return nil, errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}
}

func (m *default{{.upperStartCamelObject}}Model) TransFindOne(ctx context.Context, session sqlx.Session, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error) {
    var resp {{.upperStartCamelObject}}

    toSQL, args, err := m.Columns(ctx).Where(
    	squirrel.Eq{"{{.originalPrimaryKey}}": {{.lowerStartCamelPrimaryKey}}},
    ).Limit(1).ToSql()
    if err != nil {
    	return nil, errors.Wrap(err, "toSQL construction error")
    }

	{{if .withCache}}
	err = session.QueryRowCtx(ctx, &resp, toSQL, args...){{else}}
	err = m.conn.QueryRowCtx(ctx, &resp, toSQL, args...){{end}}
	switch err {
	case nil:
		return &resp, nil
	case ErrNotFound:
		return nil, errors.Wrap(err, fmt.Sprintf("{{.upperStartCamelObject}} not found by {{.originalPrimaryKey}}: %v", {{.lowerStartCamelPrimaryKey}}))
	default:
		return nil, errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}
}
