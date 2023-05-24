# frozen_string_literal: true

ThinkingSphinx::Index.define :comment, with: :active_record do
  # fileds
  indexes body
  indexes author.email, as: :author, sortable: true

  # attributes
  has author_id, commentable_id, commentable_type, created_at, updated_at
end
