# Preview all emails at http://localhost:3000/rails/mailers/dayly_digest
class DailyDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/dayly_digest/digest
  def digest
    DailyDigestMailer.digest
  end

end
