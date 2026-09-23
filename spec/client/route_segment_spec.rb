# frozen_string_literal: true

require 'spec_helper'

# Identifiers interpolated into route templates must be exactly one path
# segment; otherwise a caller-supplied value can swallow a helper's fixed
# action suffix and hit a different Buildkite endpoint.
#
# No cassettes: a request reaching Faraday under VCR raises
# VCR::Errors::UnhandledHTTPRequestError, so these fail loudly without the fix.
describe Buildkit::Client, 'route segment validation' do
  it 'rejects a job id that re-routes job_log to the job env endpoint' do
    expect { client.job_log('acme', 'pipe', 42, 'real-job-id/env?x') }
      .to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects a pipeline slug that substitutes another action' do
    expect { client.archive_pipeline('acme', 'victim/unarchive?ignored') }
      .to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects a build number carrying only a query delimiter' do
    expect { client.cancel_build('acme', 'pipe', '42?') }
      .to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects dot segments that URI resolution would collapse' do
    expect { client.organization('..') }
      .to raise_error(Buildkit::InvalidRouteSegment)
    expect { client.pipeline('acme', '.') }
      .to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects percent-encoded delimiters in build identifiers' do
    expect { client.artifacts('acme', 'pipe', '42%2Fjobs') }
      .to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects empty and nil identifiers' do
    expect { client.pipeline('acme', '') }.to raise_error(Buildkit::InvalidRouteSegment)
    expect { client.pipeline('acme', nil) }.to raise_error(Buildkit::InvalidRouteSegment)
  end

  it 'rejects slashes in agent ids with an ArgumentError' do
    expect { client.stop_agent('acme', 'a/b') }.to raise_error(ArgumentError)
  end
end
