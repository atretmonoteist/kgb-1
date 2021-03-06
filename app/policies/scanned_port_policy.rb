class ScannedPortPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        ScannedPort.all
      else
        organizations_ids = OrganizationPolicy::Scope.
          new(@user, Organization).resolve.pluck(:id)
        ScannedPort.where("organization_id IN (#{organizations_ids.join(', ')})")
      end
    end
  end

  def index?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

  def destroy?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

end
