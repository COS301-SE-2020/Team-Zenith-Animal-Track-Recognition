import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';
import { Observable } from 'rxjs';
import { startWith, map } from 'rxjs/operators';

export interface StateGroup {
  letter: string;
  names: string[];
}

export const _filter = (opt: string[], value: string): string[] => {
  const filterValue = value.toLowerCase();

  return opt.filter(item => item.toLowerCase().indexOf(filterValue) === 0);
};

@Component({
  selector: 'app-ranger-search-sidenav-comp',
  templateUrl: './ranger-search-sidenav-comp.component.html',
  styleUrls: ['./ranger-search-sidenav-comp.component.css']
})
export class RangerSearchSidenavCompComponent implements OnInit {

  currentAlphabet: any;
  surnames: boolean = true;
  levels: boolean = false;
  sorted: string;
  searchText: string;
  @Input() rangers;
  @Input('rangerAutocompletePanel') classList: string
  @Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();

  stateForm: FormGroup = this._formBuilder.group({
    stateGroup: '',
  });

  stateGroups: StateGroup[] = [{
    letter: 'A',
    names: ['Alabama', 'Alaska', 'Arizona', 'Arkansas']
  }, {
    letter: 'C',
    names: ['California', 'Colorado', 'Connecticut']
  }, {
    letter: 'D',
    names: ['Delaware']
  }, {
    letter: 'F',
    names: ['Florida']
  }, {
    letter: 'G',
    names: ['Georgia']
  }, {
    letter: 'H',
    names: ['Hawaii']
  }, {
    letter: 'I',
    names: ['Idaho', 'Illinois', 'Indiana', 'Iowa']
  }, {
    letter: 'K',
    names: ['Kansas', 'Kentucky']
  }, {
    letter: 'L',
    names: ['Louisiana']
  }, {
    letter: 'M',
    names: ['Maine', 'Maryland', 'Massachusetts', 'Michigan',
      'Minnesota', 'Mississippi', 'Missouri', 'Montana']
  }, {
    letter: 'N',
    names: ['Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
      'New Mexico', 'New York', 'North Carolina', 'North Dakota']
  }, {
    letter: 'O',
    names: ['Ohio', 'Oklahoma', 'Oregon']
  }, {
    letter: 'P',
    names: ['Pennsylvania']
  }, {
    letter: 'R',
    names: ['Rhode Island']
  }, {
    letter: 'S',
    names: ['South Carolina', 'South Dakota']
  }, {
    letter: 'T',
    names: ['Tennessee', 'Texas']
  }, {
    letter: 'U',
    names: ['Utah']
  }, {
    letter: 'V',
    names: ['Vermont', 'Virginia']
  }, {
    letter: 'W',
    names: ['Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
  }];

  stateGroupOptions: Observable<StateGroup[]>;

  constructor(private _formBuilder: FormBuilder) { }

  ngOnInit(): void {
    this.stateGroupOptions = this.stateForm.get('stateGroup')!.valueChanges
      .pipe(startWith(''), map(value => this._filterGroup(value)));
  }

  private _filterGroup(value: string): StateGroup[] {
    if (value) {
      return this.stateGroups
        .map(group => ({ letter: group.letter, names: _filter(group.names, value) }))
        .filter(group => group.names.length > 0);
    }

    return this.stateGroups;
  }

  checkIfNew(title: string, pos: number) {
    if (this.currentAlphabet === ('' + title).charAt(pos).toLowerCase()) {
      return false;
    } else {
      this.currentAlphabet = ('' + title).charAt(pos).toLowerCase();
      return true;
    }
  }

  toggle(bool: boolean) {
    this.surnames = bool;
    this.levels = !bool;
    this.sort(bool);
  }

  sort(bool: boolean) {
    let temp: string;
    if (bool) {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
      temp = 'Sorted alphabetically';
    } else {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
      temp = "Sorted by ranger level";
    }
    this.sorted = temp;
    return temp;
  }
}
