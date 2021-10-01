const RIESGO_DE_FIRMA = "Riesgo de firma";
/** -------------------------------------
 *
 *        Utilities Function
 *
 * --------------------------------------
 */

/**
 *
 * @param {*} clientSections
 * @param {*} sectionType
 * @param {*} cyAP
 * @param {*} cyEstim
 * @param {*} iconNameCondition
 *
 * @author Eduardo Vargas
 *
 */
export const setClientSection = (clientSections, marginSum, commSum) => {
  let marginIndex = clientSections.findIndex((obj) => obj.row === "Margen Financiero");
  if (marginIndex >= 0) {
    clientSections[marginIndex].cyAP = marginSum;
    clientSections[marginIndex].cyEstim = marginSum + clientSections[marginIndex].currentYear;

    clientSections[marginIndex].iconNameCY = `utility:${
      clientSections[marginIndex].priorYear > clientSections[marginIndex].cyEstim ? "arrowdown" : "arrowup"
    }`;
  }

  let commissionIndex = clientSections.findIndex((obj) => obj.row === "Comisiones");
  if (commissionIndex >= 0) {
    clientSections[commissionIndex].cyAP = commSum;
    clientSections[commissionIndex].cyEstim = commSum + clientSections[commissionIndex].currentYear;
    clientSections[commissionIndex].iconNameCY = `utility:${
      clientSections[commissionIndex].priorYear > clientSections[commissionIndex].cyEstim ? "arrowdown" : "arrowup"
    }`;
  }

  let mrgOrdnIndex = clientSections.findIndex((obj) => obj.row === "Margen Ordinario");
  if (mrgOrdnIndex >= 0) {
    clientSections[mrgOrdnIndex].cyAP = clientSections[marginIndex].cyAP + clientSections[commissionIndex].cyAP;
    clientSections[mrgOrdnIndex].cyEstim =
      clientSections[marginIndex].cyEstim + clientSections[commissionIndex].cyEstim;

    clientSections[mrgOrdnIndex].iconNameCY = `utility:${
      clientSections[mrgOrdnIndex].priorYear > clientSections[mrgOrdnIndex].cyEstim ? "arrowdown" : "arrowup"
    }`;
  }
};

/** -------------------------------------
 *
 *               Functions
 *
 * --------------------------------------
 */

/**
 *
 * @param {*} estimationList
 * @param {*} currentEstimationIndex
 * @returns Update Margin and Commission
 *
 * @author Eduardo Vargas
 */
export const calculator = (estimationList, currentEstimationIndex, rentabilityData) => {
  let current = estimationList[currentEstimationIndex];
  let expectedDate = new Date(current.expectedDate);
  let months = current.term <= 12 - (expectedDate.getMonth() + 1) ? current.term : 12 - (expectedDate.getMonth() + 1);
  let rentabilityDataMap = JSON.parse(JSON.stringify(rentabilityData));

  if (current.opportunityValue >= 0) {
    if (current.opportunityName === RIESGO_DE_FIRMA) {
      const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
      const firstDate = new Date(new Date().getFullYear(), 11 - months, 31);
      const secondDate = new Date(new Date().getFullYear(), 11, 31);

      current.calComm = Number(
        (
          ((current.opportunityValue * Number(current.spread)) / 100 / 360) *
          Math.round(Math.abs((firstDate - secondDate) / oneDay))
        ).toFixed(2)
      );
    } else {
      current.calculatedMargin = Number((current.opportunityValue * (months * current.calcSpreadM)).toFixed(2));
      current.calComm = Number(((current.opportunityValue * current.strComm) / 100).toFixed(2));
    }
  }

  let accountId = current.opportunityId.split("-")[0];
  if (accountId === "null") {
    accountId = undefined;
  }

  let marginSum = 0;
  let commSum = 0;
  for (let i = 0; i < estimationList.length; i++) {
    if (accountId === estimationList[i].accountId) {
      marginSum = marginSum + estimationList[i].calculatedMargin;
      commSum = commSum + estimationList[i].calComm;
    }
  }

  let cRentabilityIndex = rentabilityDataMap.data.findIndex((obj) => obj.accountId === accountId);
  if (rentabilityDataMap.data.length === 1 && cRentabilityIndex === -1) {
    cRentabilityIndex = 0;
  }
  let clientSections = rentabilityDataMap.data[cRentabilityIndex].sections;
  if (cRentabilityIndex > -1) {
    if (clientSections.length > 0) {
      setClientSection(clientSections, marginSum, commSum);
    }
  }
  return rentabilityDataMap;
};

/**
 *
 * @param {*} estimationList
 * @param {*} currentEstimationIndex
 * @param {*} eventData
 *
 * @author Eduardo Vargas
 *
 */
export const updateEstimationList = (estimationList, currentEstimationIndex, eventData) => {
  let currEstimation = estimationList[currentEstimationIndex];
  if (eventData[0].hasOwnProperty("spread")) {
    currEstimation.spread = eventData[0].spread;
    console.log("calculating spread mensual", currEstimation.calcSpreadM, eventData[0].spread);
    currEstimation.calcSpreadM = Math.pow(1 + currEstimation.spread / 100, 1 / 12) - 1;
    console.log("calculated spread mensual", currEstimation.calcSpreadM);
  }
  if (eventData[0].hasOwnProperty("strComm")) {
    currEstimation.strComm = eventData[0].strComm;
  }
  if (eventData[0].hasOwnProperty("term")) {
    currEstimation.term = eventData[0].term;
  }
};
