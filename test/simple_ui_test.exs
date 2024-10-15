defmodule SimpleUiTest do
  use ExUnit.Case

  test "define simple_ui views" do
    defmodule UiExample do
      use SimpleUi
      single_view :my_card, :card, SimpleUi, []
      multi_view :my_kanban, :kanban, SimpleUi, :my_card
    end

    ui_defs = Spark.Dsl.Extension.get_entities(UiExample, [:lang])
    assert ui_defs == [
      %SimpleUi.SingleView{
        name: :my_card,
        kind: :card,
        resource: SimpleUi,
        params: []
      },
      %SimpleUi.MultiView{
        name: :my_kanban,
        kind: :kanban,
        resource: SimpleUi,
        single_view: :my_card
      }
    ]
  end

  test "reject invalid kinds" do
    assert_raise Spark.Error.DslError, fn ->
      defmodule InvalidKindSingle do
        use SimpleUi
        single_view :my_view, :invalid, SimpleUi, []
      end
    end

    assert_raise Spark.Error.DslError, fn ->
      defmodule InvalidKindMulti do
        use SimpleUi
        multi_view :my_view, :invalid, SimpleUi, :my_single_view
      end
    end
  end
end
