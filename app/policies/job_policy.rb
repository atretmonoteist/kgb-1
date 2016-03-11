class JobPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        scope.all
      else
        scope.with_roles(@user.roles.map{|role| role.name.to_sym }, @user)
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
