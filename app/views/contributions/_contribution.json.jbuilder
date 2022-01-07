json.extract! contribution, :id, :amount, :purpose, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)
