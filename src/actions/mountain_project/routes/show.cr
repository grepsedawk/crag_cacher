class MountainProject::Routes::Show < BrowserAction
  include Auth::AllowGuests

  get "/mountain_project/routes/:mp_id/?:mp_slug" do
    LuckyCache.settings.storage.fetch("mp/routes/#{params.get(:mp_id)}", as: MountainProject::Route) do
      MountainProject::Route.new(params.get(:mp_id).to_i)
    end.try do |route|
      html ShowPage, route: route
    end
  end
end
