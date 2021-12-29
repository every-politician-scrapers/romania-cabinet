module.exports = (id, startdate, enddate) => {
  qualifier = { }
  if(startdate) qualifier['P580'] = startdate
  if(enddate)   qualifier['P582'] = enddate

  return {
    id,
    claims: {
      P39: {
        value: 'Q20885066',
        qualifiers: qualifier,
        references: { P4656: 'https://ro.wikipedia.org/wiki/Ministerul_S%C4%83n%C4%83t%C4%83%C8%9Bii_(Rom%C3%A2nia)' }
      }
    }
  }
}
