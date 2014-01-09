module MandrillHeaders
  extend ActiveSupport::Concern

  included do
    after_action :add_mandrillapp_headers
  end

  private

  def add_mandrillapp_headers
    headers['X-MC-ReturnPathDomain'] = 'mail.libreunir.com'
    headers['X-MC-TrackingDomain']   = 'mail.libreunir.com'
    headers['X-MC-SigningDomain']    = 'mail.libreunir.com'
    headers['X-MC-Subaccount']       = 'libreunir'
  end
end
