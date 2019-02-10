require 'spec_helper'

describe Pallets::CLI do
  # Stub the global state so we can test what values are set, while allowing
  # the CLI to read the default values
  let(:configuration) do
    instance_spy('Pallets::Configuration',
      backend: :redis,
      backend_args: {},
      blocking_timeout: 5,
      concurrency: 2,
      job_timeout: 1800, # 30 minutes
      max_failures: 3,
      namespace: 'pallets',
      pool_size: 5,
      serializer: :json
    )
  end
  let(:logger) do
    instance_spy('Pallets::Logger', level: Logger::FATAL)
  end

  before do
    allow(Pallets).to receive(:configuration).and_return(configuration)
    allow(Pallets).to receive(:logger).and_return(logger)
  end

  context 'with --backend provided' do
    before do
      stub_const('ARGV', ['--backend=foo'])
    end

    it 'sets the given backend' do
      subject
      expect(configuration).to have_received(:backend=).with('foo')
    end
  end

  context 'with --concurrency provided' do
    before do
      stub_const('ARGV', ['--concurrency=123'])
    end

    it 'sets the given concurrency' do
      subject
      expect(configuration).to have_received(:concurrency=).with(123)
    end
  end

  context 'with --failed-job-lifespan provided' do
    before do
      stub_const('ARGV', ['--failed-job-lifespan=123'])
    end

    it 'sets the failed job lifespan' do
      subject
      expect(configuration).to have_received(:failed_job_lifespan=).with(123)
    end
  end

  context 'with --namespace provided' do
    before do
      stub_const('ARGV', ['--namespace=foo'])
    end

    it 'sets the given namespace' do
      subject
      expect(configuration).to have_received(:namespace=).with('foo')
    end
  end

  context 'with --pool-size provided' do
    before do
      stub_const('ARGV', ['--pool-size=123'])
    end

    it 'sets the given pool size' do
      subject
      expect(configuration).to have_received(:pool_size=).with(123)
    end
  end

  context 'with --quiet provided' do
    before do
      stub_const('ARGV', ['--quiet'])
    end

    it 'sets the ERROR logging level' do
      subject
      expect(logger).to have_received(:level=).with(Logger::ERROR)
    end
  end

  context 'with --require provided' do
    context 'and a valid path' do
      before do
        stub_const('ARGV', ['--require=spec_helper'])
      end

      it 'does not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'and a path that does not exist' do
      before do
        stub_const('ARGV', ['--require=foo'])
      end

      it 'raises a LoadError' do
        expect { subject }.to raise_error(LoadError)
      end
    end
  end

  context 'with --serializer provided' do
    before do
      stub_const('ARGV', ['--serializer=foo'])
    end

    it 'sets the given serializer' do
      subject
      expect(configuration).to have_received(:serializer=).with('foo')
    end
  end

  context 'with --job-timeout provided' do
    before do
      stub_const('ARGV', ['--job-timeout=123'])
    end

    it 'sets the given job timeout' do
      subject
      expect(configuration).to have_received(:job_timeout=).with(123)
    end
  end

  context 'with --blocking-timeout provided' do
    before do
      stub_const('ARGV', ['--blocking-timeout=123'])
    end

    it 'sets the given blocking timeout' do
      subject
      expect(configuration).to have_received(:blocking_timeout=).with(123)
    end
  end

  context 'with --verbose provided' do
    before do
      stub_const('ARGV', ['--verbose'])
    end

    it 'sets the DEBUG logging level' do
      subject
      expect(logger).to have_received(:level=).with(Logger::DEBUG)
    end
  end

  describe '#run' do
    let(:manager_class) { class_double('Pallets::Manager').as_stubbed_const }
    let(:manager) { instance_spy('Pallets::Manager') }
    let(:queue_class) { class_double('Queue').as_stubbed_const }
    let(:queue) { instance_spy('Queue') }

    before do
      allow(manager_class).to receive(:new).and_return(manager)
      allow(queue_class).to receive(:new).and_return(queue)
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:exit)
    end

    it 'starts the manager' do
      subject.run
      expect(manager).to have_received(:start)
    end

    context 'with an INT signal being sent' do
      before do
        allow(queue).to receive(:pop).and_return('INT')
      end

      it 'shuts down the manager' do
        subject.run
        expect(manager).to have_received(:shutdown)
      end
    end

    context 'with a TERM signal being sent' do
      before do
        allow(queue).to receive(:pop).and_return('TERM')
      end

      it 'shuts down the manager' do
        subject.run
        expect(manager).to have_received(:shutdown)
      end
    end

    context 'with a TTIN signal being sent' do
      let(:worker) { instance_double('Pallets::Worker') }
      let(:scheduler) { instance_double('Pallets::Scheduler') }

      before do
        allow(queue).to receive(:pop).and_return('TTIN')
        allow(manager).to receive(:workers).and_return([worker])
        allow(manager).to receive(:scheduler).and_return(scheduler)
        allow(worker).to receive(:id)
        allow(worker).to receive(:debug)
        allow(scheduler).to receive(:id)
        allow(scheduler).to receive(:debug)
      end

      it 'debugs all actors' do
        subject.run
        expect(worker).to have_received(:debug)
        expect(scheduler).to have_received(:debug)
      end
    end
  end
end
