import { MatDialogRef } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { FormBuilder } from '@angular/forms';
import { AddGroupsComponent } from './add-groups.component';
import { autoSpy } from 'autoSpy';

describe('AddGroupsComponent', () => {
  it('when ngOnInit is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.ngOnInit();
    // assert
    // expect(a).toEqual
  });
  it('when fillDietTypes is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.fillDietTypes();
    // assert
    // expect(a).toEqual
  });
  it('when onSubmit is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.onSubmit();
    // assert
    // expect(a).toEqual
  });
  it('when remQuotes is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.remQuotes();
    // assert
    // expect(a).toEqual
  });
  it('when closeDialog is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.closeDialog();
    // assert
    // expect(a).toEqual
  });
  it('when attachProgressbar is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.attachProgressbar();
    // assert
    // expect(a).toEqual
  });
  it('when startLoader is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.startLoader();
    // assert
    // expect(a).toEqual
  });
  it('when stopLoader is called it should', () => {
    // arrange
    const { build } = setup().default();
    const a = build();
    // act
    a.stopLoader();
    // assert
    // expect(a).toEqual
  });

});

function setup() {
  const data = autoSpy(any);
  const http = autoSpy(HttpClient);
  const formBuilder = autoSpy(FormBuilder);
  const dialogRef = autoSpy(MatDialogRef<AddGroupsComponent>);
  const builder = {
    data,
    http,
    formBuilder,
    dialogRef,
    default() {
      return builder;
    },
    build() {
      return new AddGroupsComponent(data, http, formBuilder, dialogRef);
    }
  };

  return builder;
}
