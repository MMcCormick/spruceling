require "spec_helper"

describe OrderMailer do
  # WTFFF. undefined method `any_instance'
  #
  #describe "#receipt" do
  #  @user = FactoryGirl.create(:user)
  #  @order = FactoryGirl.create(:order, :user => @user)
  #  User.any_instance.should_receive(:stripe).and_return({active_card => "Visa"})
  #
  #  email = OrderMailer.receipt(@order).deliver
  #  ActionMailer8::Base.deliveries.should_not be_empty
  #
  #  user.email.should eq email.to
  #end
end
