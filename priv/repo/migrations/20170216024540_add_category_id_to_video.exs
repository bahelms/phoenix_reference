defmodule Rumbl.Repo.Migrations.AddCategoryIdToVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      # references/1 creates a foreign key constraint
      add :category_id, references(:categories)
    end

    create index(:videos, [:category_id])
  end
end
