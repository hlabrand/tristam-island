#!/bin/ruby

$is_windows = (ENV['OS'] == 'Windows_NT')

def checkforfailures() 
    if $num_tests_failed > 0 then
        puts "\n#{$num_tests_failed}/#{$num_tests} TESTS FAILED!"
        exit
    end
end

def runtest(filename, version, inform_args)
    basename = File.basename(filename, ".inf")
    command_file = basename + ".cmd"
    compileroutput_file = basename + "_z#{version}.messages"
    transcript_file = basename + ".scr"
    output_file = basename + ".output"
    template_file = basename + ".txt"

    if $is_windows then
        puts "Someone needs to provide Windows commands"
        exit
    else
        # use specific template file is available
        specific_template = "#{basename}.z#{version}.txt"
        template_file = specific_template if File.exists? specific_template
        inform_cmd = "/home/hugo/Hobbies/0-IF/AAAAMes-jeux/outils/inform-636-beta/inform -d2esi -Cu +,puny/PunyInform-v3/lib -v#{version} #{inform_args} #{filename}"
        #inform_cmd = "/home/hugo/Hobbies/0-IF/AAAAMes-jeux/outils/inform-636-beta/inform -d2esi -Cu +,puny/PunyInform-v3fr -v#{version} #{inform_args} #{filename}"
        frotz_cmd = "frotz #{basename}.z#{version} < #{command_file}"
        prune_cmd = "tail +6 #{transcript_file} | grep -v PunyInform > #{output_file}"
        #diff_cmd = "diff -Z #{template_file} #{output_file}"
        diff_cmd = "diff -Z #{template_file} #{transcript_file}"
        diff_cmd_ignore_banner = "diff -Z #{template_file} #{output_file} | grep -v PunyInform | tail +3"
    end
    # Remove old transcripts
    File.delete transcript_file if File.exist? transcript_file

    print "#{basename}: "
    begin
        result = %x[#{inform_cmd}]
        File.open(compileroutput_file, 'w') { |file| file.write(result) }
        if result.include?("(no output)") || result.include?("Warning") then
            puts result
            raise Errno::ENOENT
        end
        $num_tests += 1
        result = %x[#{frotz_cmd}]
        result = %x[#{prune_cmd}]
        result = %x[#{diff_cmd_ignore_banner}]
        if result.empty? then
            puts "passed"
        else
            puts "failed"
            $num_tests_failed += 1
            puts %x[#{diff_cmd}]
        end
    rescue Errno::ENOENT
        puts "unable to run this test (compilation error?)"
        exit
    end
end

$num_tests = 0
$num_tests_failed = 0

# test the English version
runtest("tristam-en", 3, "")
checkforfailures

# test the French version
#runtest("tristam-fr", 3, "")
#checkforfailures

puts "\nALL TESTS PASSED"
