using Microsoft.AspNetCore.Mvc;
using Technical_Assessment_Jandre_Serfontein.Models;

public class WordAnalysisController : Controller
{
    private WordFrequencyService _service = new WordFrequencyService();

    // Show the most frequent word
    public ActionResult MostFrequentWord()
    {
        var word = _service.GetMostFrequentWord();
        return View(word);
    }

    // Show the most frequent seven-letter word
    public ActionResult MostFrequentSevenLetterWord()
    {
        var word = _service.GetMostFrequentSevenLetterWord();
        return View(word);
    }

    // Show highest Scrabble scoring words
    public ActionResult HighestScrabbleScoringWords()
    {
        var words = _service.GetHighestScrabbleScoringWords();
        return View(words);
    }
}
