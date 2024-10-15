defmodule SimpleUiTest do
  use ExUnit.Case

  defmodule MyDomain do
    use Ash.Domain, validate_config_inclusion?: false
    resources do
      resource SimpleUiTest.MyResource
    end
  end

  defmodule MyResource do
    use Ash.Resource, domain: SimpleUiTest.MyDomain
  end

  test "define simple_ui views" do
    defmodule UiExample do
      use SimpleUi
      single_view :my_card, :card, SimpleUiTest.MyResource, []
      multi_view :my_kanban, :kanban, SimpleUiTest.MyResource, :my_card
    end

    ui_defs = Spark.Dsl.Extension.get_entities(UiExample, [:lang])
    assert ui_defs == [
      %SimpleUi.SingleView{
        name: :my_card,
        kind: :card,
        resource: SimpleUiTest.MyResource,
        params: []
      },
      %SimpleUi.MultiView{
        name: :my_kanban,
        kind: :kanban,
        resource: SimpleUiTest.MyResource,
        single_view: :my_card
      }
    ]
  end

  test "reject invalid kinds" do
    assert_raise Spark.Error.DslError, fn ->
      defmodule InvalidKindSingle do
        use SimpleUi
        single_view :my_view, :invalid, SimpleUiTest.MyResource, []
      end
    end

    assert_raise Spark.Error.DslError, fn ->
      defmodule InvalidKindMulti do
        use SimpleUi
        multi_view :my_view, :invalid, SimpleUiTest.MyResource, :my_single_view
      end
    end
  end

  test "fail if resource arg is not an AshResource" do
    assert_raise Spark.Error.DslError, fn ->
      defmodule NotAnAshResource do
        use SimpleUi
        single_view :my_view, :card, :foo, []
      end
    end
  end
end
