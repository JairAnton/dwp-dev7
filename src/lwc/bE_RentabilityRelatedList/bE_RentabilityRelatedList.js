import { api, LightningElement, track, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import getData from "@salesforce/apex/BE_ProfilabilityController_cls.getRDt";
import getGrowthVariableData from "@salesforce/apex/BE_ProfilabilityController_cls.getGrowthVariableData";
import saveRentabilityDrivers from "@salesforce/apex/BE_ProfilabilityController_cls.saveRentabilityDrivers";
import { updateEstimationList, calculator } from "./be_RentabilityRelatedListUtilities";

let date = new Date().getFullYear();

let year = `${date} Estimación`;
let nextY = `${date + 1} Estimación`;

export default class bE_RentabilityRelatedList extends LightningElement {
  @api position = [{ item: 1 }];
  @api recordId;
  @api showEditButton;
  @track isModalOpen = false;
  @track rentabilityData = { data: [] };
  @track estimationData = { data: [] };

  @track sections;
  @track error;
  @track data;

  contains = true;
  defaultSortDirection = "asc";
  sortDirection = "asc";
  sortedBy;

  activeSections = ["A", "C"];
  activeSectionsMessage = false;
  _wiredResult;

  rentabilityColumns = [
    { label: "", fieldName: "row" },
    {
      label: date - 1,
      fieldName: "priorYear",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: date,
      fieldName: "currentYear",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: year,
      fieldName: "cyEstim",
      type: "currency",
      sortable: true,
      cellAttributes: {
        alignment: "left",
        iconName: { fieldName: "iconNameCY" },
        iconPosition: "left"
      }
    },
    {
      label: nextY,
      fieldName: "nextYear",
      type: "currency",
      sortable: true,
      cellAttributes: {
        alignment: "left",
        iconName: { fieldName: "iconNameNY" },
        iconPosition: "left"
      }
    }
  ];

  rentabilityModalResumeColumns = [
    { label: "", fieldName: "row" },
    {
      label: date - 1,
      fieldName: "priorYear",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: date,
      fieldName: "currentYear",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: `${date} Plan de Cuenta`,
      fieldName: "cyAP",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: `${date} Proyectado`,
      fieldName: "cyEstim",
      type: "currency",
      sortable: true,
      cellAttributes: {
        alignment: "left",
        iconName: { fieldName: "iconNameCY" },
        iconPosition: "left"
      }
    },
    {
      label: `${date + 1} Proyectado`,
      fieldName: "nextYear",
      type: "currency",
      sortable: true,
      editable: true,
      cellAttributes: {
        alignment: "left",
        iconName: { fieldName: "iconNameNY" },
        iconPosition: "left"
      }
    }
  ];

  modalEstimationColumns = [
    { label: "", fieldName: "opportunityName" },
    {
      label: "Cliente",
      fieldName: "AccountName",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: "Monto Aproximado",
      fieldName: "opportunityValue",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      label: "Plazo (meses)",
      fieldName: "term",
      type: "number",
      sortable: true,
      cellAttributes: { alignment: "left" },
      editable: true
    },
    {
      label: "Spread / Comisión (%)",
      fieldName: "spread",
      type: "number",
      sortable: true,
      cellAttributes: { alignment: "left" },
      editable: true
    },
    {
      label: "Comisión de Estructuración (%)",
      fieldName: "strComm",
      type: "number",
      sortable: true,
      cellAttributes: { alignment: "left" },
      editable: true
    }
  ];

  /**----------------------------
 *        Apex Class
 ----------------------------*/
  //#region

  setRentabilityData() {
    console.log("sending rentabilityData ...", this.rentabilityData.data);
    console.log("sending estimationData ...", [...this.estimationData.data]);
    saveRentabilityDrivers({
      rentability: JSON.stringify(this.rentabilityData.data),
      rentModUI: JSON.stringify([...this.estimationData.data]),
      recordId: this.recordId
    })
      .then((res) => {
        if (res.error) {
          console.log("Error 1", res);
        } else {
          this.isModalOpen = false;
        }
      })
      .catch((err) => {
        console.log("Error 2", err);
      });
  }

  @wire(getData, { recordId: "$recordId" })
  getRDt(data) {
    if (data.data) {
      this.rentabilityData = data.data;
    }
  }

  getEstimationData() {
    getGrowthVariableData({ recordId: this.recordId }).then((res) => {
      this.estimationData = res;
    });
  }

  wiredCallback(result) {
    this._wiredResult = result;
    if (result.data) {
      this.sections = result.data;
      this.error = null;
    } else if (result.error) {
      this.error = result.error;
      this.sections = null;
    }
  }
  //#endregion
  /**----------------------------
   *        Table Utilities
   ----------------------------*/
  //#region
  refreshData() {
    return refreshApex(this._wiredResult);
  }

  handleSectionToggle(event) {
    const openSections = event.detail.openSections;

    if (openSections.length === 0) {
      this.activeSectionsMessage = false;
    }
    if (openSections.length > 0) {
      this.activeSectionsMessage = true;
    }
  }
  sortBy(field, reverse, primer) {
    const key = primer
      ? function (x) {
          return primer(x[field]);
        }
      : function (x) {
          return x[field];
        };

    return function (a, b) {
      a = key(a);
      b = key(b);
      return reverse * ((a > b) - (b > a));
    };
  }

  onHandleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;
    const cloneData = [...this.rentabilityData];

    cloneData.sort(this.sortBy(sortedBy, sortDirection === "asc" ? 1 : -1));
    this.rentabilityData = cloneData;
    this.sortDirection = sortDirection;
    this.sortedBy = sortedBy;
  }

  handleCellChangeSection(event) {
    let [sectionType, accountId] = event.detail.draftValues[0].sectionId.split("-");
    let list = JSON.parse(JSON.stringify(this.rentabilityData));

    let accIndex = list.data.findIndex((obj) => obj.accountId === accountId);
    if (accIndex === -1) return;

    let sectionIndex = list.data[accIndex].sections.findIndex((obj) => obj.row === sectionType);
    if (sectionIndex === -1) return;

    list.data[accIndex].sections[sectionIndex].nextYear = Number(event.detail.draftValues[0].nextYear);
    list.data[accIndex].sections[sectionIndex].iconNameNY = `utility:${
      list.data[accIndex].sections[sectionIndex].cyEstim > list.data[accIndex].sections[sectionIndex].nextYear
        ? "arrowdown"
        : "arrowup"
    }`;

    let mOrdIndex = list.data[accIndex].sections.findIndex((obj) => obj.row === "Margen Ordinario");
    if (mOrdIndex === -1) return;

    list.data[accIndex].sections[mOrdIndex].nextYear = list.data[accIndex].sections
      .filter((obj) => obj.row !== "Margen Ordinario")
      .reduce((a, b) => a + b.nextYear, 0);

    list.data[accIndex].sections[mOrdIndex].iconNameNY = `utility:${
      list.data[accIndex].sections[mOrdIndex].cyEstim > list.data[accIndex].sections[mOrdIndex].nextYear
        ? "arrowdown"
        : "arrowup"
    }`;

    this.rentabilityData = list;
  }

  handleCellChange(event) {
    let list = this.estimationData.data;

    let index = list.findIndex((obj) => obj.opportunityId === event.detail.draftValues[0].opportunityId);
    if (index === -1) return;

    updateEstimationList(list, index, event.detail.draftValues);

    let asdasd = calculator(list, index, this.rentabilityData);
    this.rentabilityData = asdasd;
    //index = this.rentabilityData.findIndex((obj) => obj.accountId === );
  }
  //#endregion

  /**----------------------------
   *        Modal Utilities
   /**----------------------------*/
  //#region
  openModal() {
    this.getEstimationData();
    this.isModalOpen = true;
  }
  closeModal() {
    this.isModalOpen = false;
  }

  submitDetails() {
    this.setRentabilityData();
  }

  //#endregion
}
