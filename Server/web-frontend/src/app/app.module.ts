import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './login/login.component';
import { OverviewComponent } from './overview/overview.component';
import { AnimalsComponent } from './animals/animals.component';
import { RangersComponent } from './rangers/rangers.component';
import { GeotagsComponent } from './geotags/geotags.component';
import { SettingsComponent } from './settings/settings.component';
import { SideNavigationComponent } from './side-navigation/side-navigation.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    RangersComponent,
    GeotagsComponent,
    SettingsComponent,
    SideNavigationComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
