
func (m *default{{.upperStartCamelObject}}Model) tableName() string {
	return m.table
}

func (q *{{.upperStartCamelObject}}) SetCreatedAtAndUpdatedAt() {
	if q == nil {
		return
	}
	q.CreatedAt = time.Now().Unix()
	q.SetUpdatedAt()
}

func (q *{{.upperStartCamelObject}}) SetUpdatedAt() {
	if q == nil {
		return
	}
	q.UpdatedAt = time.Now().Unix()
}