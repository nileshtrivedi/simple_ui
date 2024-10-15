defmodule SimpleUi do
  @moduledoc false
  defmodule SingleView do
    defstruct [:name, :kind, :resource, :params]
  end

  defmodule MultiView do
    defstruct [:name, :kind, :resource, :single_view]
  end

  defmodule Dsl do
    @single_view %Spark.Dsl.Entity{
      name: :single_view,
      target: SimpleUi.SingleView,
      args: [:name, :kind, :resource, :params],
      schema: [
        name: [
          type: :atom,
          required: true,
          doc: "The single_view name"
        ],
        kind: [
          type: {:in, [:card, :row, :column]},
          required: true,
          doc: "the single_view type: card/row/column"
        ],
        resource: [
          type: {:spark, Ash.Resource},
          required: true,
          doc: "the underlying resource module for the single_view"
        ],
        params: [
          type: {:list, :string},
          required: true,
          doc: "the params for the single_view"
        ]
      ]
    }

    @multi_view %Spark.Dsl.Entity{
      name: :multi_view,
      target: SimpleUi.MultiView,
      args: [:name, :kind, :resource, :single_view],
      schema: [
        name: [
          type: :atom,
          required: true,
          doc: "The multiview name"
        ],
        kind: [
          type: {:in, [:grid, :form, :gallery, :kanban, :calendar, :map, :timeline, :hierarchy]},
          required: true,
          doc: "the multiview type: grid/form/gallery/kanban/calendar/map/timeline/hierarchy"
        ],
        resource: [
          type: {:spark, Ash.Resource},
          required: true,
          doc: "the underlying resource module for the multi_view"
        ],
        single_view: [
          type: :atom,
          required: true,
          doc: "single_view to be used in the multi_view"
        ]
      ]
    }

    @lang %Spark.Dsl.Section{
      name: :lang,
      top_level?: true,
      entities: [@single_view, @multi_view]
    }

    use Spark.Dsl.Extension, sections: [@lang]
  end

  use Spark.Dsl, default_extensions: [extensions: Dsl]
end
