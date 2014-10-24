require 'gli'

module Redmine::Installer
  class CLI
    extend GLI::App

    def self.spec
      @spec ||= Gem::Specification::load('redmine-installer.gemspec')
    end

    def self.start(argv)
      program_desc spec.summary
      version Redmine::Installer::VERSION

      desc I18n.translate(:cli_show_verbose_output)
      default_value false
      switch [:d, :debug], negatable: false

      # pre do |global_options, command, options, args|
      #   $verbose = global_options[:debug]
      # end

      desc I18n.translate(:cli_install_desc)
      arg :package
      command [:i, :install] do |c|
        c.action do |global_options, options, args|
          r_installer = Redmine::Installer::Install.new(args.first, global_options.merge(options))
          r_installer.run
        end
      end

      desc I18n.translate(:cli_upgrade_desc)
      arg :package
      command [:u, :upgrade] do |c|
        c.flag [:p, :profile]
        c.action do |global_options, options, args|
          r_upgrader = Redmine::Installer::Upgrade.new(args.first, global_options.merge(options))
          r_upgrader.run
        end
      end

      desc I18n.translate(:cli_backup_desc)
      arg :redmine_root
      command [:b, :backup] do |c|
        c.flag [:p, :profile]
        c.action do |global_options, options, args|
          r_upgrader = Redmine::Installer::Backup.new(args.first, global_options.merge(options))
          r_upgrader.run
        end
      end

      run(argv)
    end

  end
end
