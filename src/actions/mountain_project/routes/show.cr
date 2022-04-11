class MountainProject::Routes::Show < BrowserAction
  include Auth::AllowGuests

  get "/mountain_project/routes/:mp_id" do
    html ShowPage, route: MountainProject::Route.new(params.get(:mp_id).to_i)
  end
end
