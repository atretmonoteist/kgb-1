class Organization < ActiveRecord::Base

  resourcify

  validates :name, length: {minimum: 3, maximum: 255}
  validates :name, uniqueness: true
  has_many :jobs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :scanned_ports, dependent: :destroy
  has_many :services, dependent: :destroy


  def self.beholder_role_name
    :beholder
  end

  def ip_addresses
    self.services.select(:host).distinct.pluck(:host)
  end

  def detected_services
    ScannedPort.where(host: self.ip_addresses).where(state: ['filtered', 'open', 'open|filtered']).group(:port, :protocol, :host)
  end

end
