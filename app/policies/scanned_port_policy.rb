class ScannedPortPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        scope.all
      else
        scope.where(organization_id: @user.organization_id)
      end
    end
  end

  def index?
    if @user.has_any_role? :local_editor, :local_viewer
      true
    else
      false
    end
  end

end
