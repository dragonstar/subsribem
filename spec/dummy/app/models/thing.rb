class Thing < ActiveRecord::Base
  scoped_to_account
  def self.scoped_to(account)
    where(:account_id => account.id)
  end
end
