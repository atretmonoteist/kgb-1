class DashboardPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

end
