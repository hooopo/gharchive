class BodyExtractor
  attr_reader :event
  def initialize(event)
    @event = event
  end

  def extract
    review_body  = event.dig("payload", "review", "body") rescue nil
    comment_body = event.dig("payload", "comment", "body") rescue nil
    issue_body   = event.dig("payload", "issue", "body") rescue nil  
    pr_body      = event.dig("payload", "pull_request", "body") rescue nil
    release_body = event.dig("payload", "release", "body") rescue nil
    body = review_body || comment_body || issue_body || pr_body || release_body
    body = body[0..500] if body
    body
  end
end