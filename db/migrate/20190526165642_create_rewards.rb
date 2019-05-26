class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :title
      t.belongs_to :rewardable, polymorphic: true

      t.timestamps
    end
  end
end
