import fs from "fs/promises"

const input = "input.txt"
const output = "output.csv"

function cleanRawString(string) {
  if (!string) return []

  const datePattern =
    /(\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4})/g

  const gradePattern = /^\d{1,2}[a-zA-Z+]*\s*(\t.*)?$/

  const dateMatches = [...string.matchAll(datePattern)]

  if (!(dateMatches.length > 0)) return

  // remove unneeded text
  const firstMatch = dateMatches[0]
  const lastMatch = dateMatches[dateMatches.length - 1]

  const startIndex = firstMatch.index
  const endIndex = lastMatch.index + lastMatch[0].length

  const cleanedString = string.substring(startIndex, endIndex)

  const offset = startIndex

  const uniqueDatesMap = new Map()

  dateMatches.forEach((match) => {
    const date = match[0]
    const index = match.index - offset // Adjust index
    if (!uniqueDatesMap.has(date)) {
      uniqueDatesMap.set(date, index)
    }
  })

  // Convert the Map to an array for processing
  const uniqueDatesArray = Array.from(uniqueDatesMap.entries())

  // Create a Map to store the string content between unique dates
  const contentMap = new Map()

  for (let i = 0; i < uniqueDatesArray.length; i++) {
    const [currentDate, currentIndex] = uniqueDatesArray[i]
    const nextIndex =
      i < uniqueDatesArray.length - 1
        ? uniqueDatesArray[i + 1][1]
        : cleanedString.length
    const content = cleanedString.substring(currentIndex, nextIndex).trim()
    const cleanedContent = content
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line.length > 0 && line !== currentDate)
    contentMap.set(currentDate, cleanedContent)
  }

  //create entries array

  let entries = []

  contentMap.forEach((content, date) => {
    let gradeMatches = []
    //check how many entries:
    content.forEach((line, lineIndex) => {
      if (gradePattern.test(line)) {
        gradeMatches.push(lineIndex)
      }
    })

    gradeMatches.forEach((index, matchIndex) => {
      let routeName = content[index - 2]
      let location = content[index - 1]
      let [grade, notes = ""] = content[index]
        .split("\t")
        .map((entry) => entry.trim())
      let tags = []

      const nextIndex =
        matchIndex < gradeMatches.length - 1
          ? gradeMatches[matchIndex + 1] - 3
          : content.length
      for (let i = index + 1; i < nextIndex; i++) {
        tags.push(content[i])
      }

      entries.push({
        date: date,
        name: routeName,
        location: location,
        grade: grade,
        notes: notes,
        tags: tags.join(", "),
      })
    })
  })

  return entries
}

function convertToCSV(data) {
  if (!data || data.length === 0) {
    return ""
  }

  const headers = Object.keys(data[0])
  const csvRows = []

  // Add headers
  csvRows.push(headers.join(","))

  // Add rows
  for (const row of data) {
    const values = headers.map((header) => {
      const val = row[header]
      return `"${String(val).replace(/"/g, '""')}"`
    })
    csvRows.push(values.join(","))
  }

  return csvRows.join("\n")
}

async function readAndProcessFile() {
  try {
    const rawString = await fs.readFile(input, { encoding: "utf8" })
    const cleanedData = cleanRawString(rawString)

    const csv = convertToCSV(cleanedData)

    // Write to CSV file
    await fs.writeFile(output, csv, { encoding: "utf8" })
    console.log(`CSV file saved as ${output}`)
  } catch (error) {
    console.log("Error reading or processing file:", error)
  }
}

readAndProcessFile()
