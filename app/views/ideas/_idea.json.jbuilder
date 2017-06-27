json.extract! idea, :id, :name, :created_by_id, :private, :created_at, :updated_at
json.url user_idea_url(@user, idea, format: :json)
