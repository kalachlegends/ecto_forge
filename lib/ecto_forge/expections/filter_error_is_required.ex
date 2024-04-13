defmodule EctoForge.Expections.FilterErrorIsRequired do
  defexception message: """
               Filter required there:
               - find_all()
               - find()
               - get!()
               - get()
               - get_all()
               - get_all!()
               Please use MyApp.Model.get_all(%{filter: %{artem: ""}})

               You can disable this if you rewrite extension_get in EctoForgeInstanse
               """,
               status: 500
end
