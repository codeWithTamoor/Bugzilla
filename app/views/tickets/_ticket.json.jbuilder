json.extract! ticket, :id, :title, :type, :status, :developer_id, :qa_id, :project_id, :screenshot, :description, :deadline, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
