
func (m *default{{.upperStartCamelObject}}Model) byPrimaryKey(ctx context.Context, conn sqlx.SqlConn, v, primary interface{}) error {
	toSQL, args, err := m.Columns(ctx).Where(
    		squirrel.Eq{"{{.originalPrimaryField}}": primary},
    	).Limit(1).ToSql()
    	if err != nil {
    		return errors.Wrap(err, "toSQL construction error")
    	}

    	return conn.QueryRowCtx(ctx, v, toSQL, args...)
}
