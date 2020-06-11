/**
----------------------------------------------------------------------------------------------------
Name <BE_DynamicTreeGrid_Lwc>
Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
Date 2019-09-13
Description JavaScript Controller
Changes
Date        Author   Email                  Type
2019-09-13  LMBR     lolo.bravo@bbva.com    Creation
----------------------------------------------------------------------------------------------------
 */
import { LightningElement, wire, track, api } from "lwc";
import { refreshApex } from "@salesforce/apex";
import getDynamicResponse from "@salesforce/apex/BE_DynamicTreeGrid_Ctrl.getDynamicResponse";
export default class bE_DynamicTreeGrid_Lwc extends LightningElement {
  @api recordId;
  @api title;
  @api hideTitle;
  @api sObjApiName;
  @api sObjFields;
  @api sObjFieldsSOQL;
  @api keyField;
  @api keyParentField = "";
  @api filterSQOL = "";
  @api sObjFieldLabels = "";
  @api isExpanded = false;
  @api fieldOrder = "";
  @api typeOrder = "";
  @api levelData = 0;
  @api isHeaderGroup;
  @api fieldLevel = "";
  @api fieldsHeaderGroup = "";
  @api fieldsHeaderGroupSOQL = "";
  @api fieldsHeaderGroupLabels = "";
  @api keyGroup = "";
  @api filterSQOLGroup = "";
  @api formatDate = "";
  @api numGroupShow = 0;
  @api maximumFractionDigits = 2;
  @api minimumFractionDigits = 2;
  @track gridData;
  @track error;
  @track loaded = false;
  @track empty = false;
  @track gridColumns;
  @track gridExpandedRows;
  @track sObject;
  provisionedData;
  renderedCallback() {
    if (this.hasRendered) return;
    this.hasRendered = true;
    const style = document.createElement("style");
    style.innerText = `
    c-b-e_-dynamic-tree-grid_-lwc .slds-th__action {
      justify-content: center !important;
      font-weight: bold;
      }`;
    this.template.querySelector(".slds-box").appendChild(style);
    this.template.querySelector("div.slds-box").classList.add("treeGrid");
  }
  connectedCallback() {
    this.sObject = {
      sObjName: this.sObjApiName,
      sObjFields: this.sObjFieldsSOQL,
      keyField: this.keyField,
      keyParentField: this.keyParentField,
      filterSQOL: this.filterSQOL,
      fieldLevel: this.fieldLevel,
      isHeaderGroup: this.isHeaderGroup,
      keyGroup: this.keyGroup,
      filterSQOLGroup: this.filterSQOLGroup,
      formatDate: this.formatDate,
      fieldsHeaderGroup: this.fieldsHeaderGroupSOQL,
      numGroupShow: this.numGroupShow,
      fieldOrder: this.fieldOrder
    };
  }
  @wire(getDynamicResponse, {
    recordId: "$recordId",
    param: "$sObject"
  })
  wiredTreeGridData(provisionedData) {
    this.provisionedData = provisionedData;
    const { data, error } = provisionedData;
    if (data) {
      if (data.isSuccess) {
        const subLevelSize = this.initValues(data);
        if (this.isHeaderGroup) {
          this.makeDataWithGroup(data, subLevelSize);
        } else {
          this.makeData(data, subLevelSize);
        }
        this.orderAndExpandedRows();
      } else {
        this.error = data.Message;
        this.gridData = null;
        this.loaded = true;
      }
    } else if (error) {
      this.error = error;
      this.gridData = null;
      this.loaded = true;
    }
  }
  initValues(data) {
    this.empty = data.sizeData === 0 ? true : false;
    const subLevelSize =
      this.levelData <= data.sizeData ? this.levelData - 1 : data.sizeData - 1;
    this.gridColumns = this.getGridColumns(
      data.sObjFieldsMap,
      this.sObjFields,
      this.sObjFieldLabels
    );
    return subLevelSize;
  }
  orderAndExpandedRows() {
    this.gridData = this.sortData(
      this.gridData,
      this.fieldOrder,
      this.typeOrder
    );
    this.gridExpandedRows =
      this.isExpanded && this.fieldOrder != null
        ? this.setgridExpandedRows(this.gridData, this.keyField)
        : [];
    this.loaded = true;
    this.error = null;
  }
  makeData(data, subLevelSize) {
    this.gridData =
      subLevelSize > 0
        ? this.assignTreeData(
          data.treeGridData,
          this.keyParentField,
          subLevelSize
        )
        : this.assignOneLevelData(
          data.periods,
          data.treeGridData,
          this.keyParentField,
          this.isHeaderGroup,
          null
        );
  }
  makeDataWithGroup(data, subLevelSize) {
    let fields = this.fieldsHeaderGroup.split(",");
    this.gridColumns = this.getGroupHeaderColumns(
      this.gridColumns,
      data.formatPeriods,
      data.periods,
      fields,
      data.sObjFieldsMap,
      this.fieldsHeaderGroupLabels
    );
    this.gridData =
      subLevelSize > 0
        ? this.assignTreeDataWithGroup(
          data.periods,
          data.treeGridDataGroup,
          this.keyParentField,
          fields,
          subLevelSize
        )
        : this.assignOneLevelData(
          data.periods,
          data.treeGridDataGroup,
          this.keyParentField,
          this.isHeaderGroup,
          fields
        );
  }
  refreshHandle() {
    return refreshApex(this.provisionedData);
  }
  assignOneLevelData(
    periods,
    treeDataMap,
    keyParentField,
    isHeaderGroup,
    fieldsGroupHeader
  ) {
    const levelSize = "1";
    let response = [];
    for (const keyParent in treeDataMap[levelSize]) {
      if ({}.hasOwnProperty.call(treeDataMap[levelSize], keyParent)) {
        let targetObj = {};
        if (isHeaderGroup) {
          targetObj = this.createObj(
            treeDataMap[levelSize][keyParent],
            fieldsGroupHeader,
            periods
          );
        } else {
          targetObj = Object.assign({}, treeDataMap[levelSize][keyParent]);
        }
        response.push(targetObj);
      }
    }
    return response;
  }
  assignTreeData(treeDataMap, keyParentField, subLevelSize) {
    let response = new Map();
    for (let index = subLevelSize; index >= 1; index--) {
      let parentMap = new Map();
      for (const keyParent in treeDataMap[index]) {
        if ({}.hasOwnProperty.call(treeDataMap[index], keyParent)) {
          const targetObj = Object.assign({}, treeDataMap[index][keyParent]);
          parentMap.set(keyParent, targetObj);
        }
      }
      if (index === subLevelSize) {
        const targetIndex = index + 1;
        response = new Map();
        for (const key in treeDataMap[targetIndex]) {
          if ({}.hasOwnProperty.call(treeDataMap[targetIndex], key)) {
            const targetObj = Object.assign({}, treeDataMap[targetIndex][key]);
            response.set(key, targetObj);
          }
        }
      }
      response = this.getData(response, parentMap, keyParentField);
    }
    return Array.from(response.values());
  }
  assignTreeDataWithGroup(
    periods,
    treeDataMap,
    keyParentField,
    fieldsGroupHeader,
    subLevelSize
  ) {
    let response = new Map();
    for (let index = subLevelSize; index >= 1; index--) {
      let parentMap = new Map();
      for (const keyParent in treeDataMap[index]) {
        if ({}.hasOwnProperty.call(treeDataMap[index], keyParent)) {
          let targetObj = this.createObj(
            treeDataMap[index][keyParent],
            fieldsGroupHeader,
            periods
          );
          parentMap.set(keyParent, targetObj);
        }
      }
      if (index === subLevelSize) {
        const targetIndex = index + 1;
        response = new Map();
        for (const key in treeDataMap[targetIndex]) {
          if ({}.hasOwnProperty.call(treeDataMap[targetIndex], key)) {
            let targetChildObj = this.createObj(
              treeDataMap[targetIndex][key],
              fieldsGroupHeader,
              periods
            );
            response.set(key, targetChildObj);
          }
        }
      }
      response = this.getData(response, parentMap, keyParentField);
    }
    return Array.from(response.values());
  }
  getData(childMap, parentMap, keyParentField) {
    for (const iterator of childMap.values()) {
      if (iterator[keyParentField]) {
        const parentCode = iterator[keyParentField];
        let parentObj = parentMap.get(parentCode);
        if (!parentObj.hasOwnProperty("_children")) {
          Object.defineProperty(parentObj, "_children", {
            value: [],
            writable: true,
            enumerable: true,
            configurable: true
          });
        }
        parentObj._children.push(iterator);
        parentMap.set(parentCode, parentObj);
      }
    }
    return parentMap;
  }
  getGroupHeaderColumns(
    columns,
    formatPeriods,
    periods,
    fieldsGroupHeader,
    sObjFieldsMap,
    fieldsHeaderGroupLabels
  ) {
    const targetLabels = fieldsHeaderGroupLabels.split(",");
    const formatGroup = "formatGroup";
    for (const indx in periods) {
      if ({}.hasOwnProperty.call(periods, indx)) {
        for (const index in fieldsGroupHeader) {
          if ({}.hasOwnProperty.call(fieldsGroupHeader, index)) {
            let targetLabel = targetLabels[index];
            if (targetLabels[index] === formatGroup) {
              targetLabel = formatPeriods[indx];
            }
            const targetColumn = {
              label: targetLabel,
              fieldName: fieldsGroupHeader[index] + indx,
              type: sObjFieldsMap[fieldsGroupHeader[index]]
            };
            columns.push(this.asigntypeAttributes(targetColumn));
          }
        }
      }
    }
    return columns;
  }
  getGridColumns(sObjFieldsMap, fieldsApiName, fieldsLabel) {
    const targetfieldsApiName = fieldsApiName.split(",");
    const targetfieldsLabel = fieldsLabel.split(",");
    let columns = [];
    for (const indicator in targetfieldsApiName) {
      if ({}.hasOwnProperty.call(targetfieldsApiName, indicator)) {
        const targetColumn = {
          label: targetfieldsLabel[indicator],
          fieldName: targetfieldsApiName[indicator],
          type: sObjFieldsMap[targetfieldsApiName[indicator]]
        };
        columns.push(this.asigntypeAttributes(targetColumn));
      }
    }
    return columns;
  }
  createObj(objData, fieldsGroupHeader, periods) {
    let targetObj = {};
    let contPeriod = 0;
    for (let iterator of periods) {
      if ({}.hasOwnProperty.call(objData, iterator)) {
        for (const fieldName of fieldsGroupHeader) {
          const valueField = objData[iterator][fieldName];
          Object.defineProperty(targetObj, fieldName + contPeriod, {
            value: valueField,
            writable: true,
            enumerable: true,
            configurable: true
          });
        }
        targetObj = Object.assign(targetObj, objData[iterator]);
      }
      contPeriod = contPeriod + 1;
    }
    return targetObj;
  }
  sortData(gridData, fieldOrder, typeSort) {
    const typeASC = "ASC";
    if (typeSort === typeASC) {
      gridData.sort((a, b) => a[fieldOrder] - b[fieldOrder]);
    } else {
      gridData.sort((a, b) => a[fieldOrder] + b[fieldOrder]);
    }
    return gridData;
  }
  setgridExpandedRows(gridData, keyField) {
    let gridExpandedRows = new Set();
    for (const iterator of gridData) {
      gridExpandedRows.add(iterator[keyField]);
    }
    return Array.from(gridExpandedRows);
  }
  /** ASING EXTRA ATTRIBUTES OF CELLS */
  asigntypeAttributes(Obj) {
    let targetObj = { cellAttributes: { alignment: "center" } };
    switch (Obj.type) {
      case "currency":
        Object.defineProperty(targetObj, "typeAttributes", {
          value: {
            currencyCode: { fieldName: "CurrencyIsoCode" },
            maximumFractionDigits: this.maximumFractionDigits,
            minimumFractionDigits: this.minimumFractionDigits
          },
          writable: true,
          enumerable: true,
          configurable: true
        });
        Object.defineProperty(targetObj, "cellAttributes", {
          value: { alignment: "right" },
          writable: true,
          enumerable: true,
          configurable: true
        });
        break;
      case "number":
        Object.defineProperty(targetObj, "typeAttributes", {
          value: {
            maximumFractionDigits: this.maximumFractionDigits,
            minimumFractionDigits: this.minimumFractionDigits
          },
          writable: true,
          enumerable: true,
          configurable: true
        });
        Object.defineProperty(targetObj, "cellAttributes", {
          value: { alignment: "right" },
          writable: true,
          enumerable: true,
          configurable: true
        });
        break;
      case "boolean":
        Object.defineProperty(targetObj, "initialWidth", {
          value: 60,
          writable: true,
          enumerable: true,
          configurable: true
        });
        break;
      case "percent":
        Object.defineProperty(targetObj, "typeAttributes", {
          value: {
            maximumFractionDigits: this.maximumFractionDigits,
            minimumFractionDigits: this.minimumFractionDigits
          },
          writable: true,
          enumerable: true,
          configurable: true
        });
        Object.defineProperty(targetObj, "initialWidth", {
          value: 80,
          writable: true,
          enumerable: true,
          configurable: true
        });
        break;
      case "text":
        Object.defineProperty(targetObj, "initialWidth", {
          value: 300,
          writable: true,
          enumerable: true,
          configurable: true
        });
        break;
        default:
          break;
    }
    targetObj = Object.assign(Obj, targetObj);
    return targetObj;
  }
}