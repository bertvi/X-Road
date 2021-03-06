<template>
  <div class="content">
    <ValidationObserver ref="form1" v-slot="{ validate, invalid }">
      <div class="row-wrap">
        <div class="label">
          {{$t('csr.usage')}}
          <helpIcon :text="$t('csr.helpUsage')" />
        </div>

        <ValidationProvider name="crs.usage" rules="required" v-slot="{ errors }">
          <v-select
            :items="usageList"
            class="form-input"
            v-model="usage"
            :disabled="isUsageReadOnly"
          ></v-select>
        </ValidationProvider>
      </div>

      <div class="row-wrap" v-if="usage === usageTypes.SIGNING">
        <div class="label">
          {{$t('csr.client')}}
          <helpIcon :text="$t('csr.helpClient')" />
        </div>

        <ValidationProvider name="crs.client" rules="required" v-slot="{ errors }">
          <v-select
            :items="localMembersIds"
            item-text="id"
            item-value="id"
            class="form-input"
            v-model="client"
          ></v-select>
        </ValidationProvider>
      </div>

      <div class="row-wrap">
        <div class="label">
          {{$t('csr.certificationService')}}
          <helpIcon :text="$t('csr.helpCertificationService')" />
        </div>

        <ValidationProvider name="crs.certService" rules="required" v-slot="{ errors }">
          <v-select
            :items="filteredServiceList"
            item-text="name"
            item-value="name"
            class="form-input"
            v-model="certificationService"
          ></v-select>
        </ValidationProvider>
      </div>

      <div class="row-wrap">
        <div class="label">
          {{$t('csr.csrFormat')}}
          <helpIcon :text="$t('csr.helpCsrFormat')" />
        </div>

        <ValidationProvider name="crs.crsFormat" rules="required" v-slot="{ errors }">
          <v-select
            :items="csrFormatList"
            name="crs.crsFormat"
            class="form-input"
            v-model="csrFormat"
          ></v-select>
        </ValidationProvider>
      </div>

      <div class="button-footer">
        <large-button outlined @click="cancel">{{$t('action.cancel')}}</large-button>
        <large-button :disabled="invalid" @click="done">{{$t('action.continue')}}</large-button>
      </div>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { mapGetters } from 'vuex';
import { ValidationProvider, ValidationObserver } from 'vee-validate';
import HelpIcon from '@/components/ui/HelpIcon.vue';
import LargeButton from '@/components/ui/LargeButton.vue';
import SubViewTitle from '@/components/ui/SubViewTitle.vue';
import { Key, Token } from '@/types';
import { UsageTypes, CsrFormatTypes } from '@/global';
import * as api from '@/util/api';

export default Vue.extend({
  components: {
    HelpIcon,
    LargeButton,
    SubViewTitle,
    ValidationObserver,
    ValidationProvider,
  },
  props: {},
  data() {
    return {
      usageTypes: UsageTypes,
      usageList: Object.values(UsageTypes),
      csrFormatList: Object.values(CsrFormatTypes),
    };
  },
  computed: {
    ...mapGetters([
      'localMembersIds',
      'filteredServiceList',
      'isUsageReadOnly',
    ]),

    usage: {
      get(): string {
        return this.$store.getters.usage;
      },
      set(value: string) {
        this.$store.commit('storeUsage', value);
      },
    },
    csrFormat: {
      get(): string {
        return this.$store.getters.csrFormat;
      },
      set(value: string) {
        this.$store.commit('storeCsrFormat', value);
      },
    },
    client: {
      get(): string {
        return this.$store.getters.csrClient;
      },
      set(value: string) {
        this.$store.commit('storeCsrClient', value);
      },
    },
    certificationService: {
      get(): string {
        return this.$store.getters.certificationService;
      },
      set(value: string) {
        this.$store.commit('storeCertificationService', value);
      },
    },
  },
  methods: {
    done(): void {
      this.$emit('done');
    },
    cancel(): void {
      this.$emit('cancel');
    },
  },

  watch: {
    filteredServiceList(val) {
      // Set first certification service selected as default when the list is updated
      if (val && val.length === 1) {
        this.certificationService = val[0].name;
      }
    },
    localMembersIds(val) {
      // Set first client selected as defaulg when the list is updated
      if (val && val.length === 1) {
        this.client = val[0].id;
      }
    },
  },
});
</script>

<style lang="scss" scoped>
@import '../../assets/colors';

.view-wrap {
  width: 100%;
  max-width: 850px;
  margin: 10px;
}

.row-wrap {
  display: flex;
  flex-direction: row;
  align-items: baseline;
}

.label {
  width: 230px;
  display: flex;
  flex-direction: row;
  align-items: baseline;
}

.form-input {
  width: 300px;
}

.button-footer {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  justify-content: space-between;
  border-top: solid 1px $XRoad-Grey40;
  margin-top: 40px;
  padding-top: 30px;
}
</style>

