class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true
      t.integer :nominal, default: 0

      t.timestamps
    end

    add_index :votes, %i[user_id votable_id votable_type], unique: true
  end
end
