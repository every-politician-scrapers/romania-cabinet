module.exports = (id, startdate, enddate) => {
  qualifier = { }
  if(startdate) qualifier['P580'] = startdate
  if(enddate)   qualifier['P582'] = enddate

  return {
    id,
    claims: {
      P39: {
        value: 'Q21503604',
        qualifiers: qualifier,
        references: { P4656: 'https://ro.wikipedia.org/wiki/Ministerul_Agriculturii_%C8%99i_Dezvolt%C4%83rii_Rurale_(Rom%C3%A2nia)' }
      }
    }
  }
}
