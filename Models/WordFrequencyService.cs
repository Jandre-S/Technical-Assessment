using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Technical_Assessment_Jandre_Serfontein.Models
{
    public class WordFrequencyService
    {
        private string _connectionString;

        public WordFrequencyService()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MobyDickAnalysisDB"].ConnectionString;
        }

        // Insert or update word frequency
        public void InsertOrUpdateWordFrequency(string word, int frequency)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("InsertOrUpdateWordFrequency", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Word", word);
                cmd.Parameters.AddWithValue("@Frequency", frequency);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Get the most frequent word
        public WordFrequency GetMostFrequentWord()
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetMostFrequentWord", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    return new WordFrequency
                    {
                        Word = reader["Word"].ToString(),
                        Frequency = Convert.ToInt32(reader["Frequency"])
                    };
                }

                return null;
            }
        }

        // Get most frequent seven-letter word
        public WordFrequency GetMostFrequentSevenLetterWord()
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetMostFrequentSevenLetterWord", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    return new WordFrequency
                    {
                        Word = reader["Word"].ToString(),
                        Frequency = Convert.ToInt32(reader["Frequency"])
                    };
                }

                return null;
            }
        }

        // Get the highest Scrabble scoring words
        public List<WordFrequency> GetHighestScrabbleScoringWords()
        {
            List<WordFrequency> words = new List<WordFrequency>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetHighestScrabbleScoringWords", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    words.Add(new WordFrequency
                    {
                        Word = reader["Word"].ToString(),
                        Frequency = Convert.ToInt32(reader["Frequency"])
                    });
                }

                return words;
            }
        }
    }
}
