
func (m *default{{.upperStartCamelObject}}Model) FindOneBy{{.upperField}}(ctx context.Context, {{.in}}) (*{{.upperStartCamelObject}}, error) {
    schema := ctxutil.GetTenant(ctx)

    var resp {{.upperStartCamelObject}}

	{{if .withCache}}{{.cacheKey}}
    {{.cacheKeyVariable}} = cachekey.SchInit({{.cacheKeyFmt}}, schema)

	err := m.QueryRowIndexCtx(ctx, &resp, {{.cacheKeyVariable}},
	    // keyer
	    func(primary interface{}) string {
        	format := fmt.Sprintf({{.primaryKey}}, schema)
        	return fmt.Sprintf("%s%v", format, primary)
        },
	    // indexQuery
	    func(ctx context.Context, conn sqlx.SqlConn, v interface{}) (i interface{}, e error) {
		    query := fmt.Sprintf("select %s from %s where {{.originalField}} limit 1", {{.lowerStartCamelObject}}Rows, m.table)

		    return resp.{{.upperStartCamelPrimaryKey}}, conn.QueryRowCtx(ctx, &resp, query, {{.lowerStartCamelField}})
	    },
	    // primaryQuery func(ctx context.Context, conn sqlx.SqlConn, v, primary interface{}) error
	    m.byPrimaryKey,
	)
	switch err {
	case nil:
		return &resp, nil
	case ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, errors.Wrap(err, "failed to find one by {{.upperField}}")
	}
}{{else}}var resp {{.upperStartCamelObject}}
	query := fmt.Sprintf("select %s from %s where {{.originalField}} limit 1", {{.lowerStartCamelObject}}Rows, m.table )
	err := m.conn.QueryRowCtx(ctx, &resp, query, {{.lowerStartCamelField}})
	switch err {
	case nil:
		return &resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, errors.Wrap(err, "failed to find one by {{.upperField}}")
	}
}{{end}}
