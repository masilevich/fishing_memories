require "spec_helper"
include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.flash.flash_alert', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.flash.flash_notice', text: message)
  end
end