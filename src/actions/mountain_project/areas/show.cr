class MountainProject::Areas::Show < BrowserAction
  include Auth::AllowGuests

  get "/mountain_project/areas/:mp_id/?:mp_slug" do
    LuckyCache.settings.storage.fetch("mp/areas/#{params.get(:mp_id)}", as: MountainProject::Area) do
      MountainProject::Area.new(params.get(:mp_id).to_i).tap do |area|
        area.load!
      end
    end.try do |area|
      html ShowPage, area: area
    end
  end
end
