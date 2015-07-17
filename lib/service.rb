require 'base64'
require 'uri'
require 'open-uri'

class Service < ActiveRecord::Base
  has_many :accounts
  has_many :users, :through => :accounts
  default_scope { order('name') }

  def load_icon
    return self.icon if self.icon

    service_url = self.url
    service_url ||= load_url
    service_url ||= ''
    domain = URI.parse(service_url).host

    default_icon = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgI\nfAhkiAAAAHdJREFUOI2lU8EWgCAIa73+/5fXJXzgoMR2AREGAoLk8QeXKQBa\nTCQRCB7jUjAArSC7LDKH86kehSygBCjkMoFlZaInkB5I1q0KGpAKuosVCL5G\nmAFVxnkzbfNeCVbX2ZONJvpgc3Ay2L2vTIEkAHCSw14+Yfc33riTSRf77Du6\nAAAAAElFTkSuQmCC\n"
    return default_icon unless domain

    base64 = Base64.encode64(open("http://www.google.com/s2/favicons?domain=#{domain}", &:read))
    update_attribute(:icon, base64)
    base64
  end

  def load_url
    # Attempt to lazily initialize the url from the first account's url
    return nil if self.accounts.empty?
    account_url = self.accounts.first.uri
    account_url = "http://#{account_url}" unless account_url.match '//'

    base_url = "http://#{URI.parse(account_url).host}"
    update_attribute(:url, base_url)
    base_url
  end
end
