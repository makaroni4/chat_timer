# encoding: utf-8
require "sqlite3"
require "active_support/core_ext"

module ChatTimer
  class Timer
    KEYWORDS = {
      :start => %w(begin continue start),
      :stop => %w(pause break stop end)
    }

    KEYWORD_SYMBOL = "="

    class << self
      def find_marks(db_path)
        @db = SQLite3::Database.new(db_path)

        data = {}
        KEYWORDS.each do |token, words|
          words.each do |word|
            rows = @db.execute(word_query(word))

            rows.each do |row|
              chatname, author, body_xml, timestamp, chatname = row

              timestamp = Time.at(timestamp)
              timestamp = fix_timestamp(timestamp, body_xml, word)
              message = parse_message(body_xml, word)
              chat_topic = get_chat_topic(chatname)

              data[author] ||= {}
              data[author][chat_topic] ||= []
              data[author][chat_topic] << {
                word: word,
                timestamp: timestamp,
                message: message
              }
            end
          end
        end

        data.each do |author, chat_data|
          puts "\n AUTHOR: #{author} \n"
          chat_data.each do |chatname, timestamp_data|
            puts "  CHAT: #{chatname}"

            timestamp_data.sort { |a, b| a[:timestamp] <=> b[:timestamp] }.each do |row|
              puts [
                "    ",
                row[:timestamp].strftime("%k:%M %m/%d/%Y"),
                row[:word].ljust(7, ' '),
                row[:message]
              ].join(' ')
            end
          end
        end
      end

      private
      def fix_timestamp(timestamp, body_xml, word)
        hours, minutes = parse_time(body_xml, word)

        return timestamp unless hours && minutes
        if hours < 0
          puts "WARNING: You can't use negative time."
          return timestamp
        end
        timestamp.change(hour: hours, min: minutes)
      end

      def grep_word(word)
        "#{KEYWORD_SYMBOL}#{word}"
      end

      def parse_message(body_xml, word)
        body_xml.gsub(/#{KEYWORD_SYMBOL}#{word}\(?(\-?\d{1,2}:\d{1,2})?\)?/, '')
      end

      def parse_time(body_xml, word)
        grep_word, time = body_xml.match(/#{KEYWORD_SYMBOL}#{word}\(?(\-?\d{1,2}:\d{1,2})?\)?/).to_a
        if time && !time.empty?
          return time.split(':').map(&:to_i)
        end
      end

      def chat_topic_query(chatname)
        <<-SQL
          SELECT topic
          FROM Chats
          WHERE name = "#{chatname}"
          LIMIT 1;
        SQL
      end

      def get_chat_topic(chatname)
        @chat_topics ||= {}
        topic = @chat_topics[chatname]

        unless topic
          rows = @db.execute(chat_topic_query(chatname))
          @chat_topics[chatname] = rows.flatten.first
        end

        @chat_topics[chatname]
      end

      def word_query(word)
        <<-SQL
          SELECT chatname,
                 author,
                 body_xml,
                 timestamp,
                 chatname
          FROM Messages
          WHERE body_xml LIKE '#{grep_word(word)}%'
          ORDER BY TIMESTAMP DESC LIMIT 50
          OFFSET 0;
        SQL
      end
    end
  end
end
